# StreamMux
[![CircleCI](https://circleci.com/gh/jlarigakis/stream_mux/tree/master.svg?style=shield)](https://circleci.com/gh/jlarigakis/stream_mux/tree/master)

Run multiple shell commands and serve the result as an HTTP stream.

```
mix escript.build
./stream_mux "ping 8.8.8.8" "ping 8.8.4.4"
```

Then in a new tab:
```
curl localhost:4000
```

Requires Elixir.
