package main

import (
	"encoding/xml"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"strconv"
	"strings"

	"github.com/PuerkitoBio/goquery"
)

const (
	cnGofpdfDir = "."
)

type Event struct {
	XMLName xml.Name `xml:"event"`
	Id      int      `xml:"id,attr"`
	//	Id          string   `xml:"id" json:"id"`
	day         string   `xml:"day" json:"day"`
	Start       string   `xml:"start" json:"start"`
	Duration    string   `xml:"duration" json:"duration"`
	Room        string   `xml:"room" json:"room"`
	Slug        string   `xml:"slug",json:"slug"`
	Title       string   `xml:"title" json:"title"`
	SubTitle    string   `xml:"subtitle" json:"subtitle"`
	Track       string   `xml:"track" json:"track"`
	Type        string   `xml:"type" json:"type"`
	Language    string   `xml:"language",json:"language"`
	Abstract    string   `xml:"abstract",json:"abstract"`
	Description string   `xml:"description",json:"description"`
	Persons     []Person `xml:"persons>person",json:"persons"`
	Links       []Link   `xml:"links>link",json:"links"`
	Video       string   `xml:"video" json:"video"`
	End         string   `xml:"end" json:"end"`
}

type Person struct {
	XMLName    xml.Name `xml:"person"`
	Id         int      `xml:"id,attr"`
	PersonName string   `xml:",chardata"`
}

type Link struct {
	XMLName  xml.Name `xml:"link"`
	Href     string   `xml:"href,attr"`
	LinkName string   `xml:",chardata"`
}

var eventlink string
var yearflag int
var idflag int

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func ExampleScrape(anurl string) {
	//doc, err := goquery.NewDocument("http://archive.fosdem.org/2010/schedule/events/xd_packagekit.html")
	doc, err := goquery.NewDocument(anurl)
	// doc, err := goquery.NewDocument("http://archive.fosdem.org/2010/schedule/events/")
	if err != nil {
		log.Fatal(err)
	}
	anevent := &Event{}
	aperson := &Person{}
	alink := &Link{}
	//fmt.Printf("found doc: %s", doc)
	//
	/*
		sel := doc.Find(".section")
		for i := range sel.Nodes {
			anode := sel.Eq(i)
			// use `single` as a selection of 1 node
			fmt.Printf("Node in EventMeta: %d: %s \n", i, anode.Text())
		}
	*/
	var speakercount = 0
	var day, speaker, room, starttime, endtime, duration, track bool
	doc.Find(".section").Each(func(i int, s *goquery.Selection) {
		s.Find("#infobox tr").Each(func(i int, infoboxth *goquery.Selection) {
			//fmt.Printf("Content of cell %d: %s\n", i, infoboxth.Text())
			for i := range infoboxth.Nodes {
				anode := infoboxth.Eq(i)
				//fmt.Printf("Node in Infobox tr: %d: %s \n", i, anode.Text())
				// second round in range, we have seen Speakers, so this is the second time
				if speaker == true && speakercount == 0 {
					speakercount = 1
				}
				if strings.Contains(anode.Text(), "Speakers") {
					//fmt.Printf("next sections will be speakers\n")
					speaker = true
				}
				// stop adding speakers if we get to the schedule part
				if strings.Contains(anode.Text(), "Schedule") {
					//fmt.Printf("schedule start, end of speakers\n")
					speaker = false
				}
				if speaker == true && speakercount > 0 {
					aperson.Id = idflag*10 + speakercount
					aperson.PersonName = strings.TrimSpace(anode.Text())
					anevent.Persons = append(anevent.Persons, *aperson)
					speakercount++
				}
			}
			//infoboxth.Find("td").Each(func(i int, sectiontd *goquery.Selection) {
			//	fmt.Printf("Content of cell %d: %s\n", i, sectiontd.Text())
			//})
		})
		//infoboxhref := s.Find("#infobox tr")
		//for i := range infoboxhref.Nodes {
		//	anode := infoboxhref.Eq(i)
		//	fmt.Printf("Node in EventMeta met a: %d: %s \n", i, anode.Text())
		//infoboxtr := infoboxth.Find("td")
		//for i := range infoboxtr.Nodes {
		//	anode := infoboxtr.Eq(i)
		//	fmt.Printf("Node in EventMeta: %d: %s \n", i, anode.Text())
		//}
		//}
		//infoboxth := s.Find("#infobox td")
		//for i := range infoboxth.Nodes {
		//	anode := infoboxth.Eq(i)
		//	fmt.Printf("Node in EventMeta: %d: %s \n", i, anode.Text())
		//infoboxtr := infoboxth.Find("td")
		//for i := range infoboxtr.Nodes {
		//	anode := infoboxtr.Eq(i)
		//	fmt.Printf("Node in EventMeta: %d: %s \n", i, anode.Text())
		//}
		//}

		infobox := s.Find("#infobox td")
		for i := range infobox.Nodes {
			anode := infobox.Eq(i)
			// use `single` as a selection of 1 node
			//fmt.Printf("Node in EventMeta: %d: %s \n", i, anode.Text())

			//if i == 1 {
			//	//fmt.Printf("Speaker: %s\n", anode.Text())
			//	aperson.PersonName = strings.TrimSpace(anode.Text())
			//	aperson.Id = idflag
			//	anevent.Persons = []Person{*aperson}
			//	speaker = false
			//}
			if day == true {
				//fmt.Printf("Day: %s \n", anode.Text())
				anevent.day = strings.TrimSpace(anode.Text())
				day = false
			}
			if anode.Text() == "Day" {
				day = true
				speaker = false
				room = false
				starttime = false
				endtime = false
				duration = false
				track = false
			}
			if room == true {
				//fmt.Printf("Room: %s \n", anode.Text())
				anevent.Room = strings.TrimSpace(anode.Text())
				room = false
			}
			if anode.Text() == "Room" {
				day = false
				speaker = false
				room = true
				starttime = false
				endtime = false
				duration = false
				track = false
			}
			if starttime == true {
				//fmt.Printf("StartTime: %s \n", anode.Text())
				anevent.Start = anode.Text()
				starttime = false
			}
			if anode.Text() == "Start time" {
				day = false
				speaker = false
				room = false
				starttime = true
				endtime = false
				duration = false
				track = false
			}
			if endtime == true {
				//fmt.Printf("End Time: %s \n", anode.Text())
				endtime = false
			}
			if anode.Text() == "End time" {
				day = false
				speaker = false
				room = false
				starttime = false
				endtime = true
				duration = false
				track = false
			}
			if duration == true {
				//fmt.Printf("Duration: %s \n", anode.Text())
				anevent.Duration = anode.Text()
				duration = false
			}
			if anode.Text() == "Duration" {
				day = false
				speaker = false
				room = false
				starttime = false
				endtime = false
				duration = true
				track = false
			}
			if track == true {
				//	fmt.Printf("Track: %s \n", anode.Text())
				anevent.Track = strings.TrimSpace(anode.Text())
				track = false
			}
			if anode.Text() == "Track" {
				day = false
				speaker = false
				room = false
				starttime = false
				endtime = false
				duration = false
				track = true
			}

		}

		videonodes := s.Find(".event-media-link").Nodes
		//fmt.Printf("videonodes: %s\n", videonodes)
		for i := range videonodes {
			videonode := videonodes[i]
			//fmt.Printf("video type: %s\n", reflect.TypeOf(videonode))
			//fmt.Printf("data: %s\n", videonode.FirstChild.Data)
			//for c := videonode.FirstChild; c != nil; c = c.NextSibling {
			//	fmt.Printf("node: %s\n", c.Data)
			//}
			for j := range videonode.Attr {
				fmt.Printf("Attr: %s\n", videonode.Attr[j])
				attr := videonode.Attr[j]
				// first we get an href then we get a class.
				// so we first fill in the href and in the next
				// loop we fill in the type of info
				if attr.Key == "href" {
					//fmt.Printf("href: %s", attr.Val)
					alink.Href = attr.Val
					alink.LinkName = videonode.FirstChild.Data
					anevent.Links = append(anevent.Links, *alink)
				}
				/*
					if attr.Key == "class" {
						//fmt.Printf("href: %s", attr.Val)
						if attr.Val == "event-media-link event-media-link-slides-pdf" {
							alink.LinkName = "PDF"
						} else if strings.Contains(attr.Val, "event-media-link event-media-link-video") {
							alink.LinkName = "Video"
						} else {
							alink.LinkName = "Link"
						}
					}
				*/
			}
			//fmt.Printf("Type: %s, data: %s, attr: %s\n", videonode.Type, videonode.Data, videonode.Attr)
		}

		title := s.Find(".title-event").Text()
		//abstract := strings.TrimSpace(strings.Replace(s.Find(".abstract").Text(), "<p>", "&lt;p&gt;", -1))
		abstracthtml, _ := s.Find(".abstract").Html()
		//description := strings.Replace(s.Find(".description").Text(), "<p>", "&lt;p&gt;", -1)
		descriptionhtml, _ := s.Find(".description").Html()
		//description := strings.TrimSpace(strings.Replace(descriptionhtml, "<p>", "&lt;p&gt;", -1))
		/*var speaker string
		s.Find("keyword").Each(func(i int, s *goquery.Selection) {
			speaker = s.Find("a href").Text()
		})
		*/
		//fmt.Printf("Title: %s\n abstract: %s\ndescription %s\ndescriptionhtml %s\nvideo: %s\n", title, abstract, description, descriptionhtml, video)
		anevent.Id = idflag
		anevent.Title = title
		anevent.Abstract = abstracthtml
		anevent.Description = descriptionhtml
		//event_xml, _ := xml.Marshal(anevent)
		event_xml, _ := xml.MarshalIndent(anevent, "  ", "    ")
		//fmt.Println("event:", anevent, string(event_xml))
		//os.Stdout.Write(event_xml)
		fileStr := fmt.Sprintf("%s/%s-%s-%s", cnGofpdfDir, eventlink, anevent.Room, anevent.day)
		err := os.MkdirAll("eventxml", 0755)
		err = ioutil.WriteFile(fileStr, event_xml, 0644)
		check(err)

	})
}

func main() {
	if len(os.Args) != 4 {
		log.Fatalln("Usage: scrapefosdem <URL> <Year> <id>")
	}
	log.Println("Scrape URL:", os.Args[1])
	log.Println("Year:", os.Args[2])
	theStrings := strings.SplitAfter(os.Args[1], "event/")
	fmt.Printf("%q\n", theStrings)
	eventhtmllink := theStrings[1]
	yearflag64, _ := strconv.ParseInt(os.Args[2], 0, 0)
	yearflag = int(yearflag64)
	idflag64, _ := strconv.ParseInt(os.Args[3], 0, 0)
	idflag = int(idflag64)
	eventlink = strings.TrimSuffix(eventhtmllink, ".html")
	eventlink = fmt.Sprintf("%s/%s", "eventxml", eventlink)
	fmt.Printf("%q\n%s\n", theStrings, eventlink)
	//ExampleScrape("https://archive.fosdem.org/2010/schedule/events/altos_flashrom.html")
	ExampleScrape(os.Args[1])
}
