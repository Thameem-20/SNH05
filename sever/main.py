import cv2
from skimage.metrics import structural_similarity as ssim
import os
import numpy as np
import pandas as pd
from PIL import Image
from tensorflow.keras.applications.resnet50 import ResNet50, preprocess_input
from sklearn.metrics.pairwise import cosine_similarity
from IPython.display import HTML, IFrame


# Load pre-trained ResNet50 model
model = ResNet50(weights='imagenet', include_top=False, pooling='avg')

# Function to extract features from an image using ResNet50
def extract_features(image_path):
    img = Image.open(image_path)
    img = img.convert('RGB')
    img = img.resize((224, 224))
    img_array = np.expand_dims(np.array(img), axis=0)
    img_array = preprocess_input(img_array)
    features = model.predict(img_array)
    return features.flatten()

# Function to compare images using SSIM
def compare_images(image1_path, image2_path):
    img1 = cv2.imread(image1_path)
    img2 = cv2.imread(image2_path)

    target_width = min(img1.shape[1], img2.shape[1])
    target_height = min(img1.shape[0], img2.shape[0])

    img1_resized = cv2.resize(img1, (target_width, target_height))
    img2_resized = cv2.resize(img2, (target_width, target_height))

    gray_img1 = cv2.cvtColor(img1_resized, cv2.COLOR_BGR2GRAY)
    gray_img2 = cv2.cvtColor(img2_resized, cv2.COLOR_BGR2GRAY)

    similarity_index, _ = ssim(gray_img1, gray_img2, full=True)

    return similarity_index

# Function to find the most similar image in the dataset
def find_similar_image(test_features, dataset):
    max_similarity = 0
    most_similar_image = None
    most_similar_video = None

    for index, row in dataset.iterrows():
        features = extract_features(row['Image'])
        similarity = cosine_similarity([test_features], [features])[0][0]

        if similarity > max_similarity:
            max_similarity = similarity
            most_similar_image = row['Image']
            most_similar_video = row['VideoLink']

    return (most_similar_image, most_similar_video) if max_similarity > 0 else (None, None)

# Define the extended dataset
extended_dataset = pd.DataFrame({
    'Category': ['bird', 'bird', 'bird', 'bird', 'bird', 'bird', 'bird', 'bird', 'bird'],
    'VideoLink': [
        'https://youtu.be/cZdO2e8K29o?si=E5C6APHdu_0CFXnF',
        'https://youtu.be/NdC4NE-eT9E?si=lLFh6VAhIqMTmWpx',
        'https://youtu.be/yoqW5d0Puxc?si=A4RTPOu8Sp56iVzV',
        'https://youtu.be/wfPJ4jl9DPw?si=gpttmlasoEVOIhHg',
        'https://youtu.be/GTRj9vDhGQs?si=fQW7-qVpnDGDOGZp',
        'https://youtu.be/pdsE5-GWK1Y?si=BrMtpVvvGmP21tFa',
        'https://youtu.be/_q1qKtGTGgo?si=aHgsjGToVYPyNrNR',
        'https://youtu.be/a2pJImwj1WY?si=_kX6zx-9CcmzqCHR',
        'https://youtu.be/AQ26tffkIzk?si=Ab4nLjcxX2NDlQMh',
        #  'https://youtu.be/BPSh5r2xF_U?si=L7QMSkl_ioS6usks',
        # 'https://youtu.be/6QqBvy_yO_M?si=Jo1euPkFPihEGT51',
        # 'https://youtu.be/lKOVYw9R7oI?si=MCGPL2Dbbc9XDVPV',
        # 'https://youtu.be/G5f7XnfMDRo?si=dGTzVKi-kA7ff1XQ',
        # 'https://youtu.be/pgplr0UBzds?si=9CcY7JXIqyHEZ_BD',
        # 'https://youtu.be/ZlVXZD99aAQ?si=kM8mLlTJIWHBrMbh',
        # 'https://youtu.be/xweLBn-qe9Q?si=7elW0QI5h4pBFQlK',
        # 'https://youtu.be/NxYNq4sYA5I?si=s_u_z3dJbIybriee',
        # 'https://youtu.be/Ro3hhPwE4b4?si=cGSlVf2oj84XsfC6',
        # 'https://youtu.be/9yfiTfLQzGY?si=-1ubBLCgX3g95D2a'
    ],
    'Image': [
        'image_bird1.png',
        'image_bird2.png',
        'image_bird3.png',
        'image_bird4.png',
        'image_bird5.png',
        'image_bird6.png',
        'image_bird7.png',
        'image_bird8.png',
        'image_bird9.png',
        # 'image_animal.png',
        # 'image_anima2.png',
        # 'image_anima3.png',
        # 'image_anima4.png',
        # 'image_anima5.png',
        # 'image_anima6.png',
        # 'image_anima7.png',
        # 'image_anima8.png',
        # 'image_anima9.png',
        # 'image_anima10.png'
    ]
})

# Convert paths to absolute paths
extended_dataset['Image'] = extended_dataset['Image'].apply(lambda x: os.path.abspath(x))

# Path to your test image
test_image_path = 'try.png'

# Extract features from the test image
test_features = extract_features(test_image_path)

# Find the most similar image and video link using both SSIM and cosine similarity
for index, row in extended_dataset.iterrows():
    similarity_ssim = compare_images(test_image_path, row['Image'])

    most_similar_image, most_similar_video = find_similar_image(test_features, extended_dataset)
    most_similar_video_url = most_similar_video


    if similarity_ssim > 0.5 or most_similar_image:
        print(f"Test Image: {test_image_path}")
        print(f"Dataset Image: {row['Image']}")
        print(f"SSIM Index: {similarity_ssim}")
        print(f"The most similar image is: {most_similar_image}")
        print(f"The associated video link is: {most_similar_video}")
        iframe = IFrame(src=most_similar_video_url, width=560, height=315)
        display(iframe)

        print("\n")
        break
    else:
        print("No similar image found.")