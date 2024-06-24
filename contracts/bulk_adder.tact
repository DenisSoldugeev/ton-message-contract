import "@stdlib/deploy";

message Reach {
    counter: Address;
    target: Int as uint32;
}

message CounterValue {
    amount: Int as uint32;
}

contract BulkAdder with Deployable {
  target: Int as uint32;

  init() {
    self.target = 0;
  }

  // Step1
  receive(msg: Reach) {
    require(msg.target<=10, "target can't be more than 10");
    self.target = msg.target;  // 5
    send(SendParameters{
        to: msg.counter,
        value: 0,
        mode: SendRemainingValue | SendIgnoreErrors,
        body: "query".asComment()
    });
  }

  bounced(src: Reach)

  // Step 3
  receive(msg: CounterValue) {
    if(self.target > msg.amount) {
      send(SendParameters{
        to: sender(),
        value: 0,
        mode: SendRemainingValue | SendIgnoreErrors, // or  mode: 64 | +2
        body: "increment".asComment()
      });
    }
  }
}
