import React from 'react';
import {View} from 'react-native';
import {Text, TouchableRipple} from "react-native-paper";
import {todoDetailsStyle} from "../../styles/Styles";

const bgSelected = `#878787`;
const bgUnSelected = `#F1F1F1`;

const textSelected = `#F1F1F1`;
const textUnselected = `#878787`;

export default class PeriodSelector extends React.Component {
    render() {
        const {periodList} = this.props;
        return <View style={{marginTop: 24}}>
            {periodList.map(period => {
                return createButton(period, false)
            })}
        </View>
    }
}

const createButton = (period, isSelected) => {
    const bgColor = isSelected ? bgSelected : bgUnSelected;
    const textColor = isSelected ? textSelected : textUnselected;
    return <TouchableRipple
        style={{...todoDetailsStyle.periodSelectorContainer, backgroundColor: bgColor}}
        borderless={true}
        onPress={() => {

        }}>
        <View style={todoDetailsStyle.periodSelectorContainerWrapper}>
            <Text style={{...todoDetailsStyle.periodSelectorText, color: textColor}}>
                Every {period.toLowerCase()}
            </Text>
            <View style={{...todoDetailsStyle.periodSelectorIndicator, backgroundColor: textColor}}/>
        </View>
    </TouchableRipple>
};
