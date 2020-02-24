import Action from "../action/todos";
import {calculateTimestamp} from "../utils";

const _initialState = {
    items: [],
    selectedFilter: 'all'
};

export const reducer = (state = _initialState, action) => {
    console.log(`reducer action: ${JSON.stringify(action)}`);
    const newState = { ...state };
    switch(action.type) {
        case Action.Type.TODO_ADD: {
            newState.items = [
                ...newState.items,
                {
                    id: action.id,
                    title: action.title,
                    periodUnit: action.periodUnit,
                    period: action.period,
                    timestamp: calculateTimestamp(action.period, action.periodUnit)
                }
            ];
            break;
        }
        case Action.Type.TODO_EDIT: {
            newState.items = newState.items.map((todo, _) => {
                if (todo.id === action.id) {
                    return {
                        id: action.id,
                        title: action.title,
                        periodUnit: action.periodUnit,
                        period: action.period,
                        timestamp: calculateTimestamp(action.period, action.periodUnit)
                    }
                }
                return todo
            });
            break;
        }
        case Action.Type.TODO_RESET: {
            newState.items = newState.items.map((todo, _) => {
                if (todo.id === action.id) {
                    return Object.assign({}, todo, {
                        timestamp: calculateTimestamp(todo.period, todo.periodUnit)
                    })
                }
                return todo
            });
            break;
        }
        case Action.Type.TODO_DELETE: {
            newState.items = [...newState.items];
            const index = newState.items.map((item) => { return item.id; })
                .indexOf(action.id);
            if (index > -1) {
                newState.items.splice(index, 1);
            }
            break;
        }
    }
    return newState;
};
