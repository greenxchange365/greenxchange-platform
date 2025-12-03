// pages/auth/signin.tsx
import { useState } from 'react';
import { supabase } from '../../lib/supabaseClient';

export default function SigninPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [msg, setMsg] = useState('');

  async function signUp(e: any) {
    e.preventDefault();
    setMsg('');
    const { data, error } = await supabase.auth.signUp({ email, password });
    if (error) setMsg('Sign up error: ' + error.message);
    else setMsg('Sign-up started. Check your email for confirmation link (or sign in).');
  }

  async function signIn(e: any) {
    e.preventDefault();
    setMsg('');
    const { data, error } = await supabase.auth.signInWithPassword({ email, password });
    if (error) setMsg('Sign in error: ' + error.message);
    else setMsg('Signed in successfully.');
  }

  async function signOut() {
    await supabase.auth.signOut();
    setMsg('Signed out.');
  }

  return (
    <div style={{ maxWidth:600, margin:'40px auto', fontFamily:'Arial' }}>
      <h2>Sign in / Sign up</h2>
      <form>
        <input value={email} onChange={e=>setEmail(e.target.value)} placeholder="Email" style={{width:'100%', padding:8}}/>
        <br/><br/>
        <input value={password} onChange={e=>setPassword(e.target.value)} placeholder="Password" type="password" style={{width:'100%', padding:8}}/>
        <br/><br/>
        <button onClick={signIn} style={{marginRight:8}}>Sign In</button>
        <button onClick={signUp} style={{marginRight:8}}>Sign Up</button>
        <button type="button" onClick={signOut}>Sign Out</button>
      </form>
      <p style={{marginTop:12}}>{msg}</p>
      <p style={{color:'#666'}}>Use Sign Up to create an account, then Sign In.</p>
    </div>
  );
}
