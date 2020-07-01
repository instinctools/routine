import moment from "moment";
import {Period, ResetType} from "./constants";
import {View, ActivityIndicator} from "react-native";
import React from "react";

export const calculateTimestamp = (period, periodUnit, resetType, currentTimestamp) => {
    let date
    if (resetType === ResetType.BY_PERIOD || currentTimestamp == null) {
        date = moment()
    } else {
        date = moment(currentTimestamp)
    }

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
    return date.startOf('d').toDate();
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
    if (period === 1) {
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

export const pickColorBetween = (index, maxIndex = 15, color1 = [255, 190, 67], color2 = [255, 57, 55]) => {
    let w1 = 1;
    if (index < maxIndex) {
        w1 = index / maxIndex
    }
    const w2 = 1 - w1;
    const colorRGB = [Math.round(color1[0] * w1 + color2[0] * w2),
        Math.round(color1[1] * w1 + color2[1] * w2),
        Math.round(color1[2] * w1 + color2[2] * w2)];
    return `rgba(${colorRGB[0]}, ${colorRGB[1]}, ${colorRGB[2]}, 1)`;
};

export const getProgress = () => {
    let style = {
        position: "absolute",
        width: "100%",
        height: "100%"
    };
    return (Platform.OS === 'ios') ? <ActivityIndicator style = {style} size="large"/> :
        <ActivityIndicator style = {style} size={48} />
};
