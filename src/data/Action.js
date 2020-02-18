import {store} from "../data/Store";
import {ACTION_TODO_ADD, ACTION_TODO_RESET} from "./Reducer";

let id = -1;

export function addTodo(title, periodUnit, period) {
    console.log(`action addTodo, text: ${title} periodUnit: ${periodUnit} period: ${period}`);
    id++;
    store.dispatch({
        type: ACTION_TODO_ADD,
        id: id,
        title: title,
        periodUnit: periodUnit,
        period: period,
    })
}

export function resetTodo(id) {
    console.log(`action resetTodo id: ${id}`);
    store.dispatch({
        type: ACTION_TODO_RESET,
        id: id
    });
}

export default ACTION_TODO_ADD
