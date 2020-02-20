import Action from "../action/todos";
import moment from "moment";

const _initialState = {
    items: [],
    selectedFilter: 'all'
};

export const reducer = (state = _initialState, action) => {
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
                    timestamp: calculateTimestamp(action.periodUnit, action.period)
                }
            ];
            break;
        }
        case Action.Type.TODO_RESET: {
            newState.items = newState.items.map((todo, _) => {
                if (todo.id === action.id) {
                    return Object.assign({}, todo, {
                        timestamp: calculateTimestamp(todo.periodUnit, todo.period)
                    })
                }
                return todo
            });
            break;
        }
    }
    return newState;
};

const calculateTimestamp = (periodUnit, period) => {
    let date = moment();
    switch (periodUnit) {
        case Action.Period.WEEK:
            date.add(period, `w`);
            break;
        case Action.Period.MONTH:
            date.add(period, `M`);
            break;
        case Action.Period.DAY:
        default:
            date.add(period, `d`);
            break;
    }
    return date.toISOString();
};
