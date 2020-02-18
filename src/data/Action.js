export const ACTION_TODO_ADD = `ACTION_TODO_ADD`;
export const ACTION_TODO_RESET = `ACTION_TODO_RESET`;

let id = -1;

export function addTodo(text, periodUnit, period) {
    console.log(`action addTodo, text: ${text} periodUnit: ${periodUnit} period: ${period}`);
    id++;
    return {
        type: ACTION_TODO_ADD,
        id: id,
        periodUnit: periodUnit,
        period: period,
    }
}

export function resetTodo(id) {
    console.log(`action resetTodo id: ${id}`);
    return {
        type: ACTION_TODO_RESET,
        id: id
    }
}
