import * as React from 'react';
import {createStackNavigator} from 'react-navigation-stack';
import {createAppContainer} from 'react-navigation';
import {Provider} from "react-redux";

import {store} from "./src/store";

import TodoList from './src/ui/items';
import TodoDetails from './src/ui/details';

const AppNavigator = createStackNavigator(
    {
        Items: TodoList,
        Details: TodoDetails,
    },
    {
        initialRouteName: "Items",
    },
);

const AppContainer = createAppContainer(AppNavigator);

export default class App extends React.Component {
    render() {
        return (
            <Provider store={store}>
                <AppContainer />
            </Provider>
        );
    }
}
