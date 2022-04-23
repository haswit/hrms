import requests,json

serverKey = 'AAAACeE6T20:APA91bFEjK19rDDV2iiaUSpSKRxdKvAF0nK6KueACxj0y93-pOzjFClGvMFcx9rE3FgyicnYp4xc0Nna8OxDbVNA1yqDscrdaIVA-RI_L_lT30YdvLfP55lkA6o7T6KDyFZ6DCCuTble'
data = json.dumps({
          'notification': {'body': 'Notification body', 'title': 'Notification title'},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': '/topics/all',
        })
r = requests.post(
    url= "https://fcm.googleapis.com/fcm/send",data=data, headers= {
          'Content-Type': 'application/json',
          'Authorization': f'key={serverKey}',
        },
)

print(r.status_code)
print(r.text)