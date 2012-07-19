/*
 * Copyright (c) <2012>, <Go Daddy Operating Company, LLC>
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml;
using System.Xml.Xsl;

namespace ATUL_v1
{
    public class TokenManager
    {
        private XmlDocument SubjectXml;
        private List<KeyValuePair<string, string>> tokens;

        public void Load(string xml)
        {
            // will probably need to add xml headers to doc string as it comes in
            XmlDocument x = new XmlDocument();
            x.Load(XmlReader.Create(new System.IO.StringReader(xml)));
            this.Load(x);
        }

        public void Load(XmlDocument doc)
        {
            this.SubjectXml = doc;
            this.ExtractTokens(this.SubjectXml, string.Empty);
        }

        public void Load(List<KeyValuePair<string, string>> tokens)
        {
            this.tokens = tokens;
        }

        private void ExtractTokens(XmlNode x, string nameRoot)
        {
            string name = x.Name;            
            if (nameRoot.Trim() != string.Empty)
            {
                name = nameRoot + ":" + name;
            }
            if (x.HasChildNodes)
            {
                foreach (XmlNode n in x)
                {
                    this.ExtractTokens(n, name);
                }
            }
            else
            {
                name = "@" + name + "@";
                string val = x.InnerText;
                KeyValuePair<string, string> k = new KeyValuePair<string, string>(name, val);
                this.tokens.Add(k);
            }
        }

        public string ProcessTokenizedText(string tokenizedString)
        {
            string processed = string.Empty;
            bool foundOne = false;
            do
            {
                foreach (KeyValuePair<string, string> token in this.tokens)
                {
                    
                    if (tokenizedString.Contains(token.Key) && token.Value != null && token.Value != String.Empty)
                    {
                        if (token.Key != token.Value)
                        {
                            tokenizedString = tokenizedString.Replace(token.Key, token.Value);
                            foundOne = true;
                        }
                    }
                }
            } while (foundOne);
            
            return processed;
        }

        public List<KeyValuePair<string, string>> GetTokens()
        {
            if (this.tokens == null)
            {
                throw new Exception("You must load tokens first, either with xml or directly.");
            }
            return this.tokens;
        }

        public List<string> GetTokenKeys()
        {
            if (this.tokens == null)
            {
                throw new Exception("You must load tokens first, either with xml or directly.");
            }
            List<string> keys = new List<string>();
            foreach (KeyValuePair<string, string> k in this.tokens)
            {
                keys.Add(k.Key);
            }
            return keys;
        }
    }
}