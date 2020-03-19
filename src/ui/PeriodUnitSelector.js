import {Chip} from "react-native-paper";
import {withTheme} from 'react-native-paper';
import React from "react";

function PeriodUnitSelector(props) {
    console.log(`PeriodUnitSelector theme: ${JSON.stringify(props.theme)}`);
    return (
        <Chip mode="outlined"
              theme={props.theme}
              selected={props.unit === props.selectedUnit}
              onPress={props.onPress}>
            {props.unit}{props.amount > 1 ? "S" : ""}
        </Chip>
    )
}

export default withTheme(PeriodUnitSelector);
