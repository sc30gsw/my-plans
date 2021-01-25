function rule(){
  const userId = document.getElementById("user_id");
  const password = document.getElementById("user_password");
  const passwordConfirmation = document.getElementById("user_password_confirmation");

  userId.addEventListener("keyup", () => {
    const userNameRule = document.getElementById("username-rule");
    const userMessage = "半角英数字のみ16文字以内";
    const userHTML = `
      <div class="username-rule">
        <p>${userMessage}</p>
      </div>`;
    userNameRule.insertAdjacentHTML("afterend", userHTML);
    userNameRule.remove();
  })

  password.addEventListener("click", () => {
    let passwordRule = document.getElementById("password-rule");
    let passwordMessage = "半角英数字のみ(両方含む)8文字以上";
    let passwordHTML = `
      <div class="password-rule">
        <p>${passwordMessage}</p>
      </div>`;
    passwordRule.insertAdjacentHTML("afterend", passwordHTML);
    passwordRule.remove();
  })

  passwordConfirmation.addEventListener("click", () => {
    let passwordRule = document.getElementById("password-rule");
    let passwordMessage = "半角英数字のみ(両方含む)8文字以上";
    let passwordHTML = `
      <div class="password-rule">
        <p>${passwordMessage}</p>
      </div>`;
    passwordRule.insertAdjacentHTML("afterend", passwordHTML);
    passwordRule.remove();
  })
};
window.addEventListener("load", rule);