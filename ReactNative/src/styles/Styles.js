import {StyleSheet} from 'react-native';

export const todoListStyle = StyleSheet.create({
    container: {
        paddingTop: 12,
        paddingBottom: 12
    },
    item: {
        flexDirection: `column`,
        padding: 8,
        marginBottom: 4,
        borderRadius: 10,
        marginHorizontal: 16,
        marginVertical: 4
    },
    itemHeader: {
        flexDirection: `row`,
        justifyContent: 'space-between',
    },
    itemFooter: {
        flexDirection: `row`,
        justifyContent: 'space-between',
        fontSize: 14,
    },
    itemHeaderText:{
        fontSize: 18,
        color: `#ffffff`
    },
    itemFooterText:{
        fontSize: 14,
        color: `rgba(255, 255, 255, 0.7)`
    },
    itemSwipeContent:{
        flex: 1,
        justifyContent: `center`,
        alignItems: `center`,
        width: 96,
        borderRadius: 10,
        marginVertical: 4
    },
    itemSwipeText:{
        fontSize:20,
        color: `#FFFFFF`
    },
    itemExpiredSeparator:{
        height: 1,
        marginVertical: 12,
        marginHorizontal: 16,
        backgroundColor: "rgba(0,0,0,0.2)"
    }
});

export const todoDetailsStyle = StyleSheet.create({
    root: {
        marginHorizontal: 16,
    },
    title: {
        fontSize: 30
    },
    period: {
        padding: 8,
    },
    periodUnitContainer: {
        padding: 8,
        flexDirection: `row`,
        justifyContent: 'space-evenly',
    },
    separatorContainer: {
        marginTop: 16,
        flexDirection: `row`,
        alignItems: `center`
    },
    separatorLine: {
        flex: 1,
        height: 1,
        backgroundColor: `#AAA9A9`
    },
    separatorText: {
        marginLeft: 24,
        flexGrow: 1,
        paddingHorizontal: 16,
        backgroundColor: `#ffffff`,
        color: `#AAA9A9`,
        fontSize: 16,
        position: 'absolute',
        alignSelf: 'center'
    },
    periodUnitSelectorContainer:{
        borderRadius: 10,
        marginVertical: 8
    },
    periodUnitSelectorContainerWrapper:{
        flexDirection: `row`,
        flex: 1,
        alignItems: `center`,
        margin: 16
    },
    periodUnitSelectorText:{
        flex: 1,
        fontSize: 20,
    },
    periodUnitSelectorIndicator:{
        width: 12,
        height: 12,
        borderRadius: 8
    },
    periodSelectorContainer: {
        flex: 1,
        justifyContent: `flex-end`,
        backgroundColor: `rgba(0, 0, 0, 0.2)`
    },
    periodSelectorCancelWrapper: {
        backgroundColor: `#F1F1F1`,
        borderRadius: 16
    },
    periodSelectorCancel: {
        borderRadius: 16,
        alignSelf: 'flex-start',
        padding: 16
    },
    periodSelectorPicker: {
        backgroundColor: `#F1F1F1`
    }
});

export const toolbarStyle = StyleSheet.create({
    title: {
        fontSize: 32,
        fontWeight: 'bold'
    },
    menuItem:{
        width: 48,
        height: 48,
        justifyContent: 'center',
        alignItems: 'center',
        borderRadius: 32
    },
    menuText: {
        fontWeight: 'bold'
    }
});
