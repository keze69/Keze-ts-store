
const cart = [];
function qs(sel){return document.querySelector(sel)}
function qsa(sel){return document.querySelectorAll(sel)}

function updateCartUI(){
  const wrap = qs('#cartItems');
  if(!wrap) return;
  wrap.innerHTML = '';
  let total = 0;
  cart.forEach((item,idx)=>{
    const el = document.createElement('div');
    el.className = 'cart-item';
    el.innerHTML = `<div>${item.name} x${item.qty}</div><div>₹${(item.price*item.qty).toFixed(2)}</div>`;
    wrap.appendChild(el);
    total += item.price*item.qty;
  });
  qs('#cartTotal').innerText = `₹${total.toFixed(2)}`;
}

function addToCart(id,name,price){
  const existing = cart.find(i=>i.id===id);
  if(existing){ existing.qty+=1; } else { cart.push({id,name,price,qty:1}); }
  updateCartUI();
  openCart();
}

function openCart(){
  qs('#cartModal').style.display='flex';
}
function closeCart(){ qs('#cartModal').style.display='none'; }

document.addEventListener('click', e=>{
  if(e.target.classList.contains('add-to-cart')){
    const card = e.target.closest('.card');
    const id = card.dataset.id;
    const name = card.querySelector('.pname').innerText;
    const price = parseFloat(card.dataset.price);
    addToCart(id,name,price);
  }
  if(e.target.id==='cartToggle') openCart();
  if(e.target.id==='closeCart') closeCart();
  if(e.target.id==='gpayBtn'){
    // demo fake payment - just show success message
    alert('Demo payment: Thank you! (This is not a real payment gateway.)');
    cart.length = 0;
    updateCartUI();
    closeCart();
  }
});

// contact form basic validation
qs('#contactForm').addEventListener('submit', function(ev){
  ev.preventDefault();
  const name = qs('#name').value.trim();
  const email = qs('#email').value.trim();
  if(!name || !email){ alert('Please enter name and email'); return; }
  alert('Message sent (demo). We will contact you at ' + email);
  qs('#contactForm').reset();
});

// small fade-in animation for cards
window.addEventListener('load', ()=>{
  qsa('.card').forEach((c,i)=>{ c.style.opacity=0; setTimeout(()=>{ c.style.transition='opacity .6s ease, transform .4s ease'; c.style.opacity=1; }, 100 + i*80); });
});
