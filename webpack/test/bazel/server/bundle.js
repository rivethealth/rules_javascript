(() => {
  "use strict";
  new (class {
    constructor(t) {
      this.content = t;
    }
    print() {
      console.log(this.content + "2");
    }
  })("Example3").print();
})();
