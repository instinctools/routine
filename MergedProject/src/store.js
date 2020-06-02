import {combineReducers, createStore, applyMiddleware} from 'redux';
import {reducer} from './reducer/todos';
import { createLogger } from 'redux-logger'
import AsyncStorage from '@react-native-community/async-storage';
import {persistReducer, persistStore} from "redux-persist";
import thunkMiddleware from 'redux-thunk'

const loggerMiddleware = createLogger();

const persistConfig = {
    key: 'todos',
    storage: AsyncStorage,
};

export const store = createStore(combineReducers({
        todos: persistReducer(persistConfig, reducer)
    }),
    applyMiddleware(
        thunkMiddleware,
        loggerMiddleware
    )
);
export const persistor = persistStore(store);
