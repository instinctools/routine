# Routine
__Once task list. No calendar. No date. No priority.__

`Implemented on React Native`

![Promo image](/images/promo.png)

# Implementation details
Application written using [Redux](https://redux.js.org/) library (with [official React bindings for Redux](https://react-redux.js.org/)) which implements the idea of [Flux](https://facebook.github.io/flux/) pattern but in quite a simpler way. It means that app has a unidirectional data flow that makes it easy to develop applications that are easy to test and maintain.

![Redux scheme](/images/redux.png)

> In Redux there's a `Store` which holds a `State` object that represents the state of the whole application. Every application event (either from the user or external) is represented as an `Action` that gets dispatched to a `Reducer` function. This `Reducer` updates the `Store` with a new `State` depending on what `Action` it receives. And whenever a new `State` is pushed through the `Store` the `View` is recreated to reflect the changes.

For navigation app uses [react-navigation](https://reactnavigation.org/) and [react-navigation-stack](https://reactnavigation.org/docs/stack-navigator) - the community solution as standalone library.

Persistence is implemented via [redux-persist](https://github.com/rt2zz/redux-persist) library which stores information from Redux State to a database using [async-storage](https://github.com/react-native-community/async-storage) extension.

Application also uses [react-native-swipeable-row](https://github.com/Cederman/react-native-swipeable) for swipe actions on the list items and [moment](https://momentjs.com/) for date and time manipulations.