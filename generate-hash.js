const bcrypt = require('bcryptjs');

// Password yang mau di-hash
const password = 'Password123!';

// Generate hash
bcrypt.hash(password, 10, (err, hash) => {
    if (err) {
        console.error('Error:', err);
        return;
    }

    console.log('\n=================================');
    console.log('PASSWORD:', password);
    console.log('=================================');
    console.log('BCRYPT HASH:');
    console.log(hash);
    console.log('=================================\n');
    console.log('Copy hash di atas dan replace di RAILWAY_SEED_DATA.sql');
});
