const core = require('@actions/core');
const { WebClient, ErrorCode } = require('@slack/web-api');

async function run() {
  try {
    const token = await core.getInput('token', { required: true });
    const param = await core.getInput('payload', { required: true });

    const web = new WebClient(token);

    console.log('Input:', param);
    const payload = JSON.parse(param);
    console.log('Output:', JSON.stringify(payload));

    return web.chat.postMessage(payload)
      .then((result) => {
        // The result contains an identifier for the message, `ts`.
        console.log(`Successfully send message ${result.ts}`);
      })
      .catch((err) => {
        if (err.code === ErrorCode.PlatformError) {
          console.log(err.data);
        } else {
          console.log(err);
        }
        core.setFailed("Failed to send slack message");
      });
  } catch(err) {
    console.log(err);
    core.setFailed("Failed to send slack message");
  }
}

run();
