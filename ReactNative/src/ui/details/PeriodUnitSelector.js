import React from 'react';
import {View} from 'react-native';
import {Text, TouchableRipple} from "react-native-paper";
import {todoDetailsStyle, toolbarStyle} from "../../styles/Styles";
import {connect} from "react-redux";
import ActionEditTodo from "../../action/EditTodoAction";
import {Period, PeriodsList} from "../../constants";
import PeriodSelector from "./PeriodSelector";
import analytics from "@react-native-firebase/analytics";
import Icon from "react-native-vector-icons/Ionicons";

const bgSelected = `#77767E`;
const bgUnSelected = `#EEEDF0`;

const textSelected = `#E1E1E1`;
const textUnselected = `#8B8D8E`;

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
            <TouchableRipple style={toolbarStyle.menuItem}
                             borderless={true}
                             onPress={()=>{

                             }}>
                <Icon name="md-menu" size={24} color={textColor}/>
            </TouchableRipple>
            <Text style={{...todoDetailsStyle.periodUnitSelectorText, color: textColor, textAlign: `right`}}>
                Every {period.toLowerCase()}
            </Text>
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
