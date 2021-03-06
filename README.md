# POOF

[check]: http://www.inwayhosting.com/assets/images/tick.png

POOF is a Pseudo-Object Oriented Framework for the Kerbal Space Program mod kOS.

This framework is a **WORK IN PROGRESS** and is subject to change nearly constantly. Feel free to experiment, but know that
breaking changes are going to be fairly common until I get certain aspects of the design worked out. I'm writing this for myself,
but I figured I might as well let everyone else look at it if they want to.

## Design Goals and Features

![checkbox][check] indicates that the feature is implemented.

* Loop-based design pattern - All of the controllers (objects) have a core function called from a central loop ![checkbox][check]
* Modular design - Each controller is its own object and generally has scope within itself only, unless public functions are implemented ![checkbox][check]
* Semi-automated garbage collector - Controllers can mark themselves to be collected by a garbage collector. Garbage collection happens automatically during the central loop. ![checkbox][check]
* System state recovery - In the case that a controller crashes everything and the kOS core returns to the idle state, a secondary core can provide recovery capabiilty by restarting the main core.
* Priority queue services - The executive program will run high-priority programs first, and if a particular length of time elapses, unrun programs will not be run in that loop.
* Inheritance - Some sort of well-defined ability for controllers to inherit from other controllers. The details are vague right now.
* Controller-based telemetry - Each controller has its own telemetry output, allowing the controller to transmit data about itself. ![checkbox][check]

### Finite State Machine

I'm adding a finite state machine that will allow better sequencing control and a more compact codebase and smaller set of executables.

* Finite State Machine extension allowing better sequencing control while staying within the existing pseudo-object framework. ![checkbox][check]
* Core code written to support extension. ![checkbox][check]
* FSM Guidance. ![checkbox][check]
* FSM IO
* FSM Utils

## Additional Considerations

### kOS Version
This framework is running on a slightly-modified version of kOS, which allows files to be read or written on Windows without file locking.
Therefore, certain parts of the framework (such as the telemetry and uplink components) are not guaranteed to work on a stock version of
kOS.

### Speed
For obvious reasons, this framework cannot run code super fast. For sanity's sake, you should never write blocking code (i.e. don't use the `wait` command), as this will stop EVERYTHING while it is executed and destroys the point of having this framework in the first place.
If you want to wait a particular amount of time, use a timer.
