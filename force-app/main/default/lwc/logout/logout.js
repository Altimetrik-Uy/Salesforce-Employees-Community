import { LightningElement } from 'lwc';

export default class Logout extends LightningElement {

    handleClick(){
        window.location.href="/secur/logout.jsp";
    }
}