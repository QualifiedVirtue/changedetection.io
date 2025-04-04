from apprise import AppriseAsset

# Refer to:
# https://github.com/caronc/apprise/wiki/Development_API#the-apprise-asset-object

APPRISE_APP_ID = "Shadow Pol Pals Change Detector"
APPRISE_APP_DESC = "Shadow Pol Pals Change Detector"
APPRISE_APP_URL = ""
APPRISE_AVATAR_URL = "https://raw.githubusercontent.com/dgtlmoon/changedetection.io/master/changedetectionio/static/images/avatar-256x256.png"

apprise_asset = AppriseAsset(
    app_id=APPRISE_APP_ID,
    app_desc=APPRISE_APP_DESC,
    app_url=APPRISE_APP_URL,
    image_url_logo=APPRISE_AVATAR_URL,
)
