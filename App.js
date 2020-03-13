import * as React from 'react';
import {createStackNavigator} from 'react-navigation-stack';
import {createAppContainer} from 'react-navigation';
import {Provider} from "react-redux";

import { store, persistor } from './src/store';
import { PersistGate } from 'redux-persist/integration/react'

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
                <PersistGate loading={null} persistor={persistor}>
                    <AppContainer />
                </PersistGate>
            </Provider>
        );
    }
}
