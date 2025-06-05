// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"

console.log("Hello from Functions!")

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.7.1"

// Initialize Supabase client
const supabaseUrl = 'https://xychvsmzcbmsqkkitnuf.supabase.co'
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh5Y2h2c216Y2Jtc3Fra2l0bnVmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg0Nzk5MDEsImV4cCI6MjA2NDA1NTkwMX0.MfZLMKeBCj4_26FifX-igydQGO7BeAf1vH8emmZzK_Q'
const supabase = createClient(supabaseUrl, supabaseAnonKey)

// Vonage configuration
const VONAGE_API_KEY = Deno.env.get('VONAGE_API_KEY')
const VONAGE_API_SECRET = Deno.env.get('VONAGE_API_SECRET')

serve(async (req) => {
  try {
    const { phone_number } = await req.json()

    // Generate a 6-digit OTP
    const otp = Math.floor(100000 + Math.random() * 900000).toString()

    // Store OTP in Supabase
    const { error } = await supabase
      .from('otps')
      .insert({
        phone_number,
        otp,
        expires_at: new Date(Date.now() + 5 * 60 * 1000).toISOString(),
      })

    if (error) {
      return new Response(
        JSON.stringify({ error: error.message }),
        { status: 400 }
      )
    }

    // Send SMS using Vonage REST API directly
    const response = await fetch('https://rest.nexmo.com/sms/json', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        api_key: VONAGE_API_KEY,
        api_secret: VONAGE_API_SECRET,
        to: phone_number,
        from: 'Amanah',
        text: `Your Amanah OTP is: ${otp}. Valid for 5 minutes.`
      })
    })

    const result = await response.json()

    if (result.messages?.[0]?.status === '0') {
      return new Response(
        JSON.stringify({ success: true }),
        { status: 200 }
      )
    } else {
      throw new Error(result.messages?.[0]?.error-text || 'Failed to send SMS')
    }

  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500 }
    )
  }
})

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/send-otp' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
