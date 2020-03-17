import moment from "moment";
import {Period} from "./constants";

export const calculateTimestamp = (period, periodUnit, from = moment()) => {
    let date = moment(from);
    console.log(`calculateTimestamp: ${date.toISOString()}`);
    switch (periodUnit) {
        case Period.WEEK:
            date.add(period, `w`);
            break;
        case Period.MONTH:
            date.add(period, `M`);
            break;
        case Period.DAY:
        default:
            date.add(period, `d`);
            break;
    }
    return date.format("YYYY-MM-DD");
};

export const calculateTargetDate = (date) => {
    let startOfDay = moment().startOf("day");
    let diffDays = date.diff(startOfDay, `d`);
    if (diffDays === 0) {
        return "Today"
    } else if (diffDays === 1) {
        return "Tomorrow"
    } else if (diffDays === 7) {
        return "1 week left"
    } else if (diffDays > 1 && diffDays < 7) {
        return `${diffDays} days left`
    } else if (diffDays === -1) {
        return "Yesterday"
    } else if (diffDays < -1) {
        return date.fromNow();
    }
    return null;
};

export const prettyPeriod = (period, periodUnit) => {
    if (period === "1") {
        if (periodUnit === Period.DAY) {
            return "Every day"
        } else if (periodUnit === Period.WEEK) {
            return "Once a week"
        } else if (periodUnit === Period.MONTH) {
            return "Once a month"
        } else {
            return `Every ${periodUnit.toLowerCase()}`
        }
    } else if (period > 1) {
        return `Every ${period} ${periodUnit.toLowerCase()}s`
    }
    return null;
};
