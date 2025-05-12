import cv2
import sys
import time


cap = cv2.VideoCapture(0)
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)
if not cap.isOpened():
    print("camera open error")
    exit()


while True:
    ret, image=cap.read()
    if not ret:
        print("frame read error")
        break
    cv2.imshow('CAMERA', image)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

    if cv2.waitKey(30)>0:
        break
    time.sleep(10)
    cv2.imwrite("image.jpg",image)

cap.release()
cv2.destroyAllWindows()
