import React from 'react';
import {View} from 'react-native';
import {Text, TouchableRipple} from "react-native-paper";
import {todoDetailsStyle} from "../../styles/Styles";
import {connect} from "react-redux";
import ActionEditTodo from "../../action/EditTodoAction";
import {Period, PeriodsList} from "../../constants";
import PeriodSelector from "./PeriodSelector";
import analytics from "@react-native-firebase/analytics";

const bgSelected = `#878787`;
const bgUnSelected = `#F1F1F1`;

const textSelected = `#F1F1F1`;
const textUnselected = `#878787`;

class PeriodUnitSelector extends React.Component {

    render() {
        console.log(`PeriodUnitSelector render props: ${JSON.stringify(this.props)}`);
        return <View style={{marginTop: 24}}>
            {PeriodsList.map(period => {
                return createButton(this.props, period)
            })}
            <PeriodSelector/>
        </View>
    }
}

const createButton = (props, period) => {
    const isSelected = period === props.selectedPeriodUnit;
    const bgColor = isSelected ? bgSelected : bgUnSelected;
    const textColor = isSelected ? textSelected : textUnselected;
    return <TouchableRipple
        style={{...todoDetailsStyle.periodUnitSelectorContainer, backgroundColor: bgColor}}
        borderless={true}
        onPress={() => {
            if (period === Period.DAY){
                analytics().logEvent('period_todo_react', {});
            }
            props.editTodoPeriodUnit(period);
        }}>
        <View style={todoDetailsStyle.periodUnitSelectorContainerWrapper}>
            <Text style={{...todoDetailsStyle.periodUnitSelectorText, color: textColor}}>
                Every {period.toLowerCase()}
            </Text>
            <View style={{...todoDetailsStyle.periodUnitSelectorIndicator, backgroundColor: textColor}}/>
        </View>
    </TouchableRipple>
};

const mapStateToProps = (state) => {
    return {
        selectedPeriodUnit: state.todos.editTodo.periodUnit
    };
};


export default connect(
    mapStateToProps,
    ActionEditTodo
)(PeriodUnitSelector);
