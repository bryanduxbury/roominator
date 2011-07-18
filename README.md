The Roominator is a project with the objective of producing DIY display terminals that can be posted outside of your offices' conference rooms and assist in scheduling and reservation.

The system is not a stand-alone scheduling solution - it's designed to complement an existing Google Calendar-backed room reservation setup. If you're like us here at Rapleaf, then you've probably gone so far as using Google Calendar for room reservation already. This is a pretty good system for the most part, but it has one major shortcoming: people who "just grab a room" when they need one rather than reserving. This is pretty natural behavior, especially when you've just picked up your phone and you need somewhere quiet to talk, so we want to make it easy to make ad-hoc reservations as well as avoid stealing rooms that are soon to be occupied.

The project consists of three components: an application server for interfacing with Google Calendar, a master control unit for coordinating with the displays, and one or more display units. 

Project goals:

 - Totally open-source hardware design and software
 - Keep system cost down: < $50 for displays, < $100 for the master
 - Easy to use and configure
 - Easy to expand with new displays