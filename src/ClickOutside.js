const init = () => {
    class ClickOutside extends HTMLElement {
        constructor() {
          super();
        }
        
       
        connectedCallback() {
          this.onMouseDown = e => {
            const isOutside = !document
              .getElementById("dropdown")
              .contains(e.target);

            if (isOutside) {
              var event = new CustomEvent("clickoutside");
              this.dispatchEvent(event);
            }
          }
          
          window.addEventListener("mousedown", this.onMouseDown);
        }
        
        disconnectedCallback() {
          window.removeEventListener("mousedown",this.onMouseDown);
        }
      }

      customElements.define("on-click-outside", ClickOutside);
}
export default init;