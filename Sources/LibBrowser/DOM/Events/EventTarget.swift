// [Exposed=*]
// interface EventTarget {
//   constructor();

//   undefined addEventListener(DOM.String type, EventListener? callback, optional (AddEventListenerOptions or boolean) options = {});
//   undefined removeEventListener(DOM.String type, EventListener? callback, optional (EventListenerOptions or boolean) options = {});
//   boolean dispatchEvent(Event event);
// };

// callback interface EventListener {
//   undefined handleEvent(Event event);
// };

// dictionary EventListenerOptions {
//   boolean capture = false;
// };

// dictionary AddEventListenerOptions : EventListenerOptions {
//   boolean passive;
//   boolean once = false;
//   AbortSignal signal;
// };

public extension DOM {
    class EventTarget {}
}
