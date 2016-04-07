#!/usr/bin/env node

var argv = require('yargs')
    .usage('Usage: $0 [arguments]')
    .demand(['bucket','file','dest','user','group','perms','service']) 
    .default('service','NONE')
    .argv,
    AWS = require('aws-sdk'),
    execSync = require("child_process").execSync,
    s3 = new AWS.S3(),
    fs = require('fs'),
    crypto = require('crypto'),
    tmpFile = crypto.randomBytes(20).toString('hex');

var bucket = argv.bucket,
    file = argv.file,
    dest = argv.dest,
    user = argv.user,
    group = argv.group,
    perms = argv.perms,
    service = argv.service;

writeFile();

function writeFile() {

  console.log('Downloading ' + file + ' from ' + bucket + ' to ' + dest +'/'+ file);

  tmpFile = '/tmp/' + tmpFile;

  var s3Params = {
    Bucket: bucket,
    Key: file
  };
  
  s3.getObject(s3Params, function(err, data) {
    if (err === null) {
      
      fs.writeFileSync(tmpFile, data.Body);
      execSync('/usr/bin/sudo /bin/mv -f ' + tmpFile + ' ' + dest+'/'+file);
      console.log('Done');
      setPermissions();
      if (service !== 'NONE')
        restartService();

    } else {
      console.log('Error downloading file ' + file + ' err: ' + err);
    }
  
  });

}

function setPermissions() {

  console.log('\nSetting permissions to ' + user + ':' + group + ' perms: ' + perms);
  execSync('/usr/bin/sudo /bin/chown ' + user + '.' + group + ' ' + dest +'/'+ file);
  execSync('/usr/bin/sudo /bin/chmod ' + perms + ' ' + dest +'/'+ file);
  console.log('Done');

}

function restartService() {

  console.log('\nRestarting service ' + service);
  execSync('/usr/bin/sudo /usr/sbin/service ' + service + ' restart');
  console.log('Done');

}
