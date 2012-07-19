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
using System.Xml;

namespace ATUL_v1
{
    public class Schedule
    {
        public DateTime? LastInstantiated { get; set; }

        public DateTime NextScheduledDate { get; set; }

        public long AtulProcessScheduleID { get; set; }

        public long AtulProcessID { get; set; }

        public string RepeatSchedule { get; set; }

        public string ScheduleVersion { get; set; }

        public string InstantiatedUserList { get; set; }

        /// <summary>
        /// Helper function to compare time constructs for scheduler purposes
        /// </summary>
        /// <param name="x"></param>
        /// <param name="y"></param>
        /// <returns></returns>
        public static int CompareTimes(Dictionary<string, int> x, Dictionary<string, int> y)
        {
            if (x["hours"] > y["hours"])
            {
                return 1;
            }
            else if (x["hours"] < y["hours"])
            {
                return -1;
            }
            else if (x["hours"] == y["hours"] && x["minutes"] > y["minutes"])
            {
                return 1;
            }
            else if (x["hours"] == y["hours"] && x["minutes"] < y["minutes"])
            {
                return -1;
            }
            else
            {
                return 0;
            }
        }

        public static ScheduleRepeater ParseCronString(string cronString)
        {
            ScheduleRepeater s = new ScheduleRepeater();
            string[] cronParts = cronString.Split(')');
            string timeStrings = cronParts[0].TrimStart(new char[] { '(' });
            string[] timeSetStrings = timeStrings.Split(',');
            s.Times = new List<Dictionary<string, int>>();
            foreach (string t in timeSetStrings)
            {
                string tx = t.Trim(new char[] { '[', ']' });
                string[] timeParts = tx.Split(' ');
                Dictionary<string, int> time = new Dictionary<string, int>();
                time.Add("hours", Convert.ToInt32(timeParts[1]));
                time.Add("minutes", Convert.ToInt32(timeParts[0]));
                s.Times.Add(time);
            }
            s.Times.Sort(Schedule.CompareTimes);
            string cronSchedule = cronParts[1].Trim();
            string[] scheduleParts = cronSchedule.Split(' ');
            string[] daysOfMonth = scheduleParts[0].Split(',');
            s.DaysOfMonth = new List<int>();
            for (int i = 0; i < daysOfMonth.Length; i++)
            {
                int num;
                if (Int32.TryParse(daysOfMonth[i], out num))
                {
                    s.DaysOfMonth.Add(num);
                }
            }
            s.DaysOfMonth.Sort();
            string[] monthsOfYear = scheduleParts[1].Split(',');
            s.MonthsOfYear = new List<int>();
            for (int i = 0; i < monthsOfYear.Length; i++)
            {
                int num;
                if (Int32.TryParse(monthsOfYear[i], out num))
                {
                    s.MonthsOfYear.Add(num);
                }
            }
            s.MonthsOfYear.Sort();
            string[] daysOfWeek = scheduleParts[2].Split(',');
            s.DaysOfWeek = new List<int>();
            for (int i = 0; i < daysOfWeek.Length; i++)
            {
                int num;
                if (Int32.TryParse(daysOfWeek[i], out num))
                {
                    s.DaysOfWeek.Add(num);
                }
            }
            s.DaysOfWeek.Sort();
            int x;
            if (Int32.TryParse(scheduleParts[3], out x))
            {
                s.SkipWeeks = x;
            }
            if (Int32.TryParse(scheduleParts[4], out x))
            {
                s.SkipMonths = x;
            }
            return s;
        }

        public DateTime GetNextScheduled()
        {
            ScheduleRepeater r = Schedule.ParseCronString(this.RepeatSchedule);
            DateTime current = this.NextScheduledDate;
            // if there's more than one time, and if there's a time that's later than the
            // current, let's use the same day and return later time
            foreach (Dictionary<string, int> t in r.Times)
            {
                // since we've sorted in order we loop through and return earliest time that's later than current
                if (t["hours"] > current.Hour || (t["hours"] == current.Hour && t["minutes"] > current.Minute))
                {
                    return new DateTime(current.Year, current.Month, current.Day, t["hours"], t["minutes"], 0);
                }
            }

            // if there's no other times that're later than current, we continue and set the next date
            // if there are specific dates set, we'll use the next date
            // for each of the following, we'll use r.Times[0] as it'll be the first time that day, in case
            // there are more than one time set to run

            // to start we check to see if this is set up to skip months
            if (r.SkipMonths != 0)
            {
                DateTime newDate = current.AddMonths(r.SkipMonths + 1);
                return new DateTime(newDate.Year, newDate.Month, newDate.Day, r.Times[0]["hours"], r.Times[0]["minutes"], 0);
            }

            //next we try checking for specific days of the month
            if (r.DaysOfMonth.Count > 0)
            {
                DateTime newDate;
                if (r.DaysOfMonth.Count == 1) // if there's only one day of the month, we just add a month
                {
                    newDate = current.AddMonths(1); // addmonths automatically adjusts the day of the month back if
                    // it would overflow the month
                    return new DateTime(newDate.Year, newDate.Month, newDate.Day, r.Times[0]["hours"], r.Times[0]["minutes"], 0);
                }
                // calculate number of days to add
                int addDays = 0;
                int daysThisMonth = DateTime.DaysInMonth(current.Year, current.Month);
                DateTime nextMonth = current.AddMonths(1);
                int daysNextMonth = DateTime.DaysInMonth(nextMonth.Year, nextMonth.Month);
                foreach (int date in r.DaysOfMonth)
                {
                    // here we're checking for a later date this same month
                    if (date > current.Day)
                    {
                        if (date > daysThisMonth)
                        {
                            // if it's set to run on a date that's greater than the number of days in the month,
                            // we're going to default back to the last day of the month
                            addDays = daysThisMonth - current.Day;
                        }
                        else
                        {
                            addDays = date - current.Day;
                        }
                        break;
                    }
                }

                if (addDays == 0)
                {
                    // if addDays is still 0, then whatever date we're on is the last shcduled for this month, and we
                    // need to move on to next month
                    if (r.DaysOfMonth[0] > daysNextMonth)
                    {
                        return new DateTime(nextMonth.Year, nextMonth.Month, daysNextMonth, r.Times[0]["hours"], r.Times[0]["minutes"], 0);
                    }
                    else
                    {
                        addDays = daysThisMonth - current.Day + r.DaysOfMonth[0];
                    }
                }
                if (addDays == 0)
                {
                    // if we're still running zero there may be a corner case where the process is repeating
                    // the last couple days every month and we're currently in a month that's shorter than the
                    // schedule.  So we'll just return next month
                    return new DateTime(nextMonth.Year, nextMonth.Month, daysNextMonth, r.Times[0]["hours"], r.Times[0]["minutes"], 0);
                }
                newDate = current.AddDays(addDays);
                return new DateTime(newDate.Year, newDate.Month, newDate.Day, r.Times[0]["hours"], r.Times[0]["minutes"], 0);
            }

            // if skipweeks is set we'll set a date that number of weeks ahead.
            if (r.SkipWeeks != 0)
            {
                DateTime newDate = current.AddDays(7 * (r.SkipWeeks + 1));
                return new DateTime(newDate.Year, newDate.Month, newDate.Day, r.Times[0]["hours"], r.Times[0]["minutes"], 0);
            }

            // if we're going by days of the week, we'll set to run on the next available day which matches.
            if (r.DaysOfWeek.Count > 0)
            {
                int addDays = 0;
                foreach (int day in r.DaysOfWeek)
                {
                    if (day > Convert.ToInt32(current.DayOfWeek))
                    {
                        // if there's a day later in the week
                        addDays = day - Convert.ToInt32(current.DayOfWeek);
                        break;
                    }
                }
                if (addDays == 0)
                {
                    // we couldn't find a later day this week, so we'll go to next week
                    addDays = 7 - Convert.ToInt32(current.DayOfWeek) + r.DaysOfWeek[0];
                }
                // set new date based on adding number of days
                DateTime newDate = current.AddDays(addDays);
                // return datetime with earliest runtime that day
                return new DateTime(newDate.Year, newDate.Month, newDate.Day, r.Times[0]["hours"], r.Times[0]["minutes"], 0);
            }

            throw new Exception("Cannot find next scheduled date. Parsing cronstring values yeilded no available dates.");
        }

        public XmlDocument GetScheduleMessageBodyXML()
        {
            XmlDocument doc = new XmlDocument();
            doc.LoadXml("<servicerequest><verb>INITINSTANCE</verb></servicerequest>");
            XmlNode serviceRequestNode = doc.SelectSingleNode("//servicerequest");
            XmlNode processIdElement = doc.CreateElement("parameter");
            XmlNode processIdName = doc.CreateElement("name");
            processIdName.InnerText = "AtulProcessID";
            processIdElement.AppendChild(processIdName);
            XmlNode processIdValue = doc.CreateElement("value");
            processIdValue.InnerText = AtulProcessID.ToString();
            processIdElement.AppendChild(processIdValue);
            serviceRequestNode.AppendChild(processIdElement);
            XmlNode scheduleIdElement = doc.CreateElement("parameter");
            XmlNode scheduleIdName = doc.CreateElement("name");
            scheduleIdName.InnerText = "AtulProcessScheduleID";
            scheduleIdElement.AppendChild(scheduleIdName);
            XmlNode scheduleIdValue = doc.CreateElement("value");
            scheduleIdValue.InnerText = AtulProcessScheduleID.ToString();
            scheduleIdElement.AppendChild(scheduleIdValue);
            serviceRequestNode.AppendChild(scheduleIdElement);
            XmlNode scheduleVersionElement = doc.CreateElement("parameter");
            XmlNode scheduleVersionName = doc.CreateElement("name");
            scheduleVersionName.InnerText = "ScheduleVersion";
            scheduleVersionElement.AppendChild(scheduleVersionName);
            XmlNode scheduleVersionValue = doc.CreateElement("value");
            scheduleVersionValue.InnerText = ScheduleVersion;
            scheduleVersionElement.AppendChild(scheduleVersionValue);
            serviceRequestNode.AppendChild(scheduleVersionElement);
            return doc;
        }
    }

    public struct ScheduleRepeater
    {
        public List<int> DaysOfMonth { set; get; }

        public List<int> MonthsOfYear { set; get; }

        public List<int> DaysOfWeek { set; get; }

        public int SkipWeeks { set; get; }

        public int SkipMonths { set; get; }

        public List<Dictionary<string, int>> Times { set; get; }
    }
}