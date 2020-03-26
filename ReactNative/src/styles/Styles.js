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
        backgroundColor: `#000000`
    },
    separatorText: {
        marginLeft: 24,
        flexGrow: 1,
        paddingHorizontal: 16,
        backgroundColor: `#ffffff`,
        position: 'absolute',
        alignSelf: 'center'
    },
    periodSelectorContainer:{
        height: 68,
        justifyContent: `center`,
        borderRadius: 10,
        marginVertical: 8
    },
    periodSelectorText:{
        fontSize: 20,
        paddingLeft: 16
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
