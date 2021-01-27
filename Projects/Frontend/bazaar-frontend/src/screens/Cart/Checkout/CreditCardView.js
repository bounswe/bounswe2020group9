import CreditCardCard from "./CreditCardCard/creditcardcard";

function CreditCardView(props) {
  if (props.cardModalIsOpen) {
    
    return (
      <CreditCardCard creditCard={props.editedItem} selected={false} 
               ></CreditCardCard>
    )
  } else {
    return (
      <div>

      </div>
    )
  }
}

export default CreditCardView;