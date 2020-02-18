import moment from "moment";

export const PERIOD_DAY = `PERIOD_DAY`;
export const PERIOD_WEEK = `PERIOD_WEEK`;
export const PERIOD_MONTH = `PERIOD_MONTH`;

export const ACTION_TODO_ADD = `ACTION_TODO_ADD`;
export const ACTION_TODO_RESET = `ACTION_TODO_RESET`;

export function todoReducer(state = [], action) {
    switch (action.type) {
        case ACTION_TODO_ADD:
            return [
                ...state,
                {
                    id: action.id,
                    title: action.title,
                    periodUnit: action.periodUnit,
                    period: action.period,
                    timestamp: calculateTimestamp(action.periodUnit, action.period)
                }
            ];
        case ACTION_TODO_RESET:
            return state.map((todo, _) => {
                if (todo.id === action.id) {
                    return Object.assign({}, todo, {
                        timestamp: calculateTimestamp(todo.periodUnit, todo.period)
                    })
                }
                return todo
            });
        default:
            return state
    }
}

const calculateTimestamp = (periodUnit, period) => {
    let date = moment();
    switch (periodUnit) {
        case PERIOD_WEEK:
            date.add(period, `w`);
            break;
        case PERIOD_MONTH:
            date.add(period, `M`);
            break;
        case PERIOD_DAY:
        default:
            date.add(period, `d`);
            break;
    }
    return date.toISOString();
};
