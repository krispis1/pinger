# ConcurrentPinger

Host Ping project that "works" concurrently. Just started working on the project, a lot of issues are happening at this moment. Feel free to report them on the [Issues](https://github.com/krispis1/ConcurrentPinger/issues) section above.

---

### The current process of setting up the ConcurrentPinger is this:
1. Open file **IpPinger.swift**
2. On line **16**, change the IP address to the one you'd like to ping.
3. On line **118**, adjust `pinger?.targetCount` to your needs (the amount of pings sent to one IP address).
4. On line **137**, adjust `queue.maxConcurrentOperationCount` to a number of concurrent operations happening at once (the more you go, the more messy it gets as of now).

---

# Demo

![alt text](https://media.giphy.com/media/ZIM4Q7YLxZsjFvyezi/giphy.gif)

---

### Todo
- ~~Release v0.0.1~~
- ~~Some bug fixes~~
- Everything else

---

Thanks to [SwiftyPing](https://github.com/samiyr/SwiftyPing) for making this project available.
