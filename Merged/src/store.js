import {applyMiddleware, combineReducers, createStore} from 'redux';
import {reducer} from './reducer/todos';
import {createLogger} from 'redux-logger'
import AsyncStorage from '@react-native-community/async-storage';
import {persistReducer, persistStore} from "redux-persist";
import thunkMiddleware from 'redux-thunk'
import {splashReducer} from "./reducer/SplashReducer";

const loggerMiddleware = createLogger();

const persistConfig = {
    key: 'todos',
    storage: AsyncStorage,
};

export const store = createStore(combineReducers({
        splash: splashReducer,
        todos: persistReducer(persistConfig, reducer)
    }),
    applyMiddleware(
        thunkMiddleware,
        loggerMiddleware
    )
);
export const persistor = persistStore(store);
