## HVAC Project

This is my solution for Cohesion's admission challenge. Enjoy!

![Diagrama](/assets/hvac-diagram.png)

### Considerations

The app are using RabbitMQ as the message broker. I've never used kafka before so I hope you guys dont mind. I didnt know if you guys were meaning one aggregator for each device, so for simplicity I wrote one for them all.
The lack of more tests comes from my lack of time. I did extrapolate the time for
the challenge and used the test in the HVAC Server Project for development purposes
with a normal Golden Path.

### Scalability

  - Implementation of PBT(Property-Based Testing) for more coverage.
  - More focus on data consistency.
  - Leverage on aggregator concurrency.
  - Distributed Registry with a Sharding approach to start and deactivate devices.
    in a more dinamic way.
  - Efficient caching mechanism for when the Broker fails.

### How it works


![How It Works](/assets/how_it_works.png)

Thats it for now, thanks!
