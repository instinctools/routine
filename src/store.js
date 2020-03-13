import {combineReducers, createStore} from 'redux';
import {reducer as todos} from './reducer/todos';
import AsyncStorage from '@react-native-community/async-storage';
import { persistReducer, persistStore } from "redux-persist";

const persistConfig = {
    key: 'todos',
    storage: AsyncStorage,
};

export const store = createStore(combineReducers({
    todos: persistReducer(persistConfig, todos)
}));
export const persistor = persistStore(store);
