import {combineReducers, createStore} from "redux";
import {todoReducer} from "./Reducer";

const reducer = combineReducers({todos: todoReducer});
export const store = createStore(reducer);
