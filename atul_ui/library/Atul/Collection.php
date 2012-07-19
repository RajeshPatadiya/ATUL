<?php
/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
class Atul_Collection implements IteratorAggregate, Countable
{
	/** hold the colleciton of items in an array */
	protected $_items = array();
	
	/** allow collection to store properties */
	protected $_data = array();
	
	/** callback function, if specified */
	private $_onload;
	
	/** whether the collection has been loaded */
	private $_isLoaded = false;
	
	/** Field to sort the collection by */
	private $_sortField = null;
	
	/**
	 * Optionally accept an array of properties to use for the collection, if provided,
	 * will set the properties to the data in the array provided.
	 * @params array $items (optional)
	 */
	public function __construct($properties = null)
	{
		if ($properties !== null && is_array($properties)) {
			foreach ($properties as $property => $value) {
				$this->$property = $value;
			}
			
		}
	}
	
	/**
	 * Function to satisfy the IteratorAggregate interface.  Sets an
	 * ArrayIterator instance for the server list to allow this class to be 
	 * iterable like an array.
	 */
	public function getIterator()
	{
		$this->_checkCallback();
		return new ArrayIterator($this->_items);
	}
	
	/**
	 * Function to satisfy the Countable interface, returns a count of the
	 * length of the collection
	 * @return int the collection length
	 */
	public function count()
	{
		return $this->length();
	}
	
	/** get property */
	public function __get($name)
	{
		$getMethod = 'get'.$name;
		if (method_exists($this, $getMethod)) {
			return $this->$getMethod();
		} else {
			if (isset($this->_data[$name])) {
				return $this->_data[$name];
			} else {
				return null;
			}
		}
	}
	
	/** set properties */
	public function __set($name, $value)
	{
		$setMethod = 'set'.$name;
		if (method_exists($this, $setMethod)) {
			$this->$setMethod($value);
		} else {
			$this->_data[$name] = $value;
		}
	}
	
	/**
	 * Function to add an item to the Collection, optionally specifying
	 * the key to access the item with.  Returns the item passed in for 
	 * continuing work.
	 * @param $item the object to add
	 * @param $key the accessor key (optional)
	 * @return mixed the item
	 */
	public function addItem($item, $key = null)
	{
		$this->_checkCallback();
		
		if($key !== null) {
			$this->_items[$key] = $item;
		} else {
			$this->_items[] = $item;
		}
		
		return $item;
	}
	
	/**
	 * Remove an item from the Collection identified by it's key
	 * @param $key the identifying key of the item to remove
	 */
	public function removeItem($key)
	{
		$this->_checkCallback();
		
		if(isset($this->_items[$key])) {
			unset($this->_items[$key]);
		} else {
			throw new Exception("Invalid key $key specified.");
		}
	}
	
	/**
	 * Retrieve an item from the collection as identified by its key
	 * @param $key the identifying key of the item to remove
	 * @return item identified by the key
	 */
	public function getItem($key)
	{
		$this->_checkCallback();
		
		if(isset($this->_items[$key])) {
			return $this->_items[$key];
		} else {
			throw new Exception("Invalid key $key specified.");
		}
	}
	
	/** 
	 * Function to return the entire list of servers as an array
	 * of Server objects
	 * @return array
	 */
	public function getAll()
	{
		return $this->_items;
	}
	
	/**
	 * Return the list of keys to all objects in the collection
	 * @return array an array of items
	 */
	public function keys()
	{
		$this->_checkCallback();
		return array_keys($this->_items);
	}
	
	/**
	 * Return the length of the collection of items 
	 * @return int the size of the collection
	 */
	public function length()
	{
		$this->_checkCallback();
		return sizeof($this->_items);
	}
	
	/**
	 * Check if an item with the identified key exists in the Collection
	 * @param $key the key of the item to check
	 * @return bool if the item is in the Collection
	 */
	public function exists($key)
	{
		$this->_checkCallback();
		return (isset($this->_items[$key]));
	}
	
	/**
	 * Define a callback function to be invoked prior to accessing
	 * a collection if empty.  The callback function should take a 
	 * Atul_Collection object as its parameter
	 * @param $functionName the name of the function to call
	 * @param $objOrClass the name of an object or class to call the function on (optional)
	 */
	public function setLoadCallback($functionName, $objOrClass = NULL)
	{
		if($objOrClass !== NULL) {
			$callback = array($objOrClass, $functionName);
		} else {
			$callback = $functionName;
		}
		
		// test method to make sure it is callable
		if(!is_callable($callback, false, $callableName)) {
			throw new Exception("$callableName is not callable as a parameter to onload");
			return false;
		}
		$this->_onload = $callback;
	}
	
	/**
	 * Sort the Collection by a property of the objects which is a string field 
	 * Set the sortfield first then call string comparison helper function
	 * @param $field the property name to sort by
	 */
	public function sortByString($field, $reverse = false)
	{
		$this->_sortField = $field;
		uasort($this->_items, array($this, 'strComparison'));
		if ($reverse) {
			$this->_items = array_reverse($this->_items, true);
		}
	}
	
	/**
	 * For backwards compatibility, sorts the collection by a field called name, 
	 * calling the sortByString function above 
	 */
	public function sortByName() 
	{
		$this->sortByString('name');
	}
	
	/**
	 * Helper function to allow user-supplied sorting by a string
	 * property field of the objects.  Should not be called directly
	 * because the sortfield needs to be set first.  
	 * Note that this uses strnatcmp for natural language comparison.
	 * @param $a first object
	 * @param $b second object
	 * @return integer the result of the comparison 
	 */
	private function strComparison($a, $b)
	{	
		$field = $this->_sortField;
		return strnatcmp($a->$field, $b->$field);
	}
	/**
	 * Helper method to call the callback function if one has been
	 * set and has not already been called on a collection
	 */
	private function _checkCallback()
	{
		if(isset($this->_onload) && !$this->_isLoaded) {
			$this->_isLoaded = true;
			call_user_func($this->_onload, $this);
		}
	}
	
	/**
	 * Function to return child with the id specified.  If the child
	 * is not already in the collection, it will create a new instance of
	 * that child specified by the type, add it to the collection and return.
	 * Can optionally supply $params parameter, which can be an array or a single 
	 * parameter to the new object's constructor.
	 * @param $id
	 * @param $type
	 * @param $params (optional)
	 * @return the object type requested
	 */
	public function makeChild($id, $type, $params = null)
	{
		$this->_checkCallback();
		
		if ($this->exists($id)) {
			return $this->getItem($id);
		} else {
			$child = new $type($params);
			return $this->addItem($child, $id);
		}
	}
	
	/**
	 * Function to aggregate a total for a property of
	 * all children, and their children if they are Collections or extend collection.  
	 * Only works for properties with numeric values.
	 * @param string $property the property name to aggregate
	 * @param bool $includeSelf whether to include the self properties of this collection object
	 * @return int the total aggregated value
	 */
	public function getAggregateProperty($property, $includeSelf = false)
	{
		$total = 0;
		if ($includeSelf && $this->$property !== null) {
			$total += $this->$property;
		}
		if (count($this) > 0){
			foreach ($this->_items as $item) {
				if ($item instanceof Atul_Collection) {
					$total += $item->getAggregateProperty($property, true);
				} else {
					if ($item->$property !== null) {
						$total += $item->$property;
					}
				}
			}
		}
		return $total;
	}
	
}
?>