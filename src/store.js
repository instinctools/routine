import {combineReducers, createStore} from 'redux';
import {reducer as todos} from './reducer/todos';

export const store = createStore(combineReducers({
    todos
}));
