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
        width: 96,
        backgroundColor: '#E3E3E3',
        textAlignVertical: "center",
        textAlign: "center",
        borderRadius: 10,
        fontSize:20,
        color: `#FFFFFF`,
        marginVertical: 4
    },
    itemExpiredSeparator:{
        height: 1,
        marginVertical: 12,
        marginHorizontal: 16,
        backgroundColor: "rgba(0,0,0,0.2)"
    }
});

export const todoDetailsStyle = StyleSheet.create({
    periodUnitContainer: {
        flexDirection: `row`,
        justifyContent: 'space-evenly',
    },
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
