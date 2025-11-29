const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: '.env.local' });

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseKey) {
  console.error('Error: Supabase credentials not found in .env.local');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

async function checkDatabase() {
  console.log('Checking connection to Supabase...');
  
  const { data, error } = await supabase.from('lines').select('*').limit(1);

  if (error) {
    console.error('❌ Error connecting or querying table:', error.message);
    if (error.code === '42P01') {
      console.log('\n⚠️  DIAGNOSIS: The tables do not exist yet.');
      console.log('   You need to run the SQL script in your Supabase Dashboard.');
    }
  } else {
    console.log('✅ Connection successful!');
    console.log('   Found ' + data.length + ' rows in lines table.');
    if (data.length === 0) {
      console.log('   The table exists but is empty. Did you run the INSERT statements?');
    }
  }
}

checkDatabase();
