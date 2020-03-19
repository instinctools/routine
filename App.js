import * as React from 'react';
import {createStackNavigator} from 'react-navigation-stack';
import {createAppContainer} from 'react-navigation';
import {Provider} from "react-redux";

import {store, persistor} from './src/store';
import {PersistGate} from 'redux-persist/integration/react'
import {DefaultTheme, Provider as PaperProvider} from 'react-native-paper';

import TodoList from './src/ui/items';
import TodoDetails from './src/ui/details';

const AppNavigator = createStackNavigator(
    {
        Items: TodoList,
        Details: TodoDetails,
    }
);

const AppContainer = createAppContainer(AppNavigator);

const theme = {
    ...DefaultTheme,
    colors: {
        ...DefaultTheme.colors,
        primary: '#EC2F67',
        accent: '#FDB44C',
    },
};

export default class App extends React.Component {
    render() {
        return (
            <Provider store={store}>
                <PersistGate loading={null} persistor={persistor}>
                    <PaperProvider theme={theme}>
                        <AppContainer/>
                    </PaperProvider>
                </PersistGate>
            </Provider>
        );
    }
}
