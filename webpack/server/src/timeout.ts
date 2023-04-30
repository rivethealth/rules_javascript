import { Subject } from "rxjs";

export function clearTimeout_(
  delegate: typeof clearTimeout,
): typeof clearTimeout {
  return <any>function (this: any, handle: any) {
    if (handle?.unsubscribe) {
      handle.unsubscribe();
      return;
    }
    return Reflect.apply(delegate, this, arguments);
  };
}

export function setTimeout_(
  delegate: typeof setTimeout,
  time: number,
  event: Subject<void>,
): typeof setTimeout {
  return <any>function (this: any, callback: Function, time_: number) {
    if (time_ === time) {
      const subscription = event.subscribe(() => {
        subscription.unsubscribe();
        callback();
      });
      return subscription;
    }
    return Reflect.apply(delegate, this, arguments);
  };
}
