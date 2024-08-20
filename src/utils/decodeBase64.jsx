const decodeBase64Data = (dataObject) => {
    try {
        const base64String = dataObject.data.split(',')[1]; // Extract Base64 part
        const decodedString = atob(base64String); // Decode Base64 string
        const jsonData = JSON.parse(decodedString); // Parse JSON string
        return jsonData;
    } catch (error) {
        console.error('Error decoding and parsing JSON:', error);
        return null;
    }
};

// const exampleData = {
//     data: "data:application/json;base64,eyJ3YWxsZXRfYWRkcmVzcyI6IjB4OTc2ZWE3NDAyNmU3MjY1NTRkYjY1N2ZhNTQ3NjNhYmQwYzNhMGFhOSIsInBvc2l0aW9uIjoiYmFzZVN0YXRpb24iLCJ1bml0Ijp7Im5hbWUiOiJCcmF2byBDb21tYW5kZXIifSwibG9jYXRpb24iOnsibGF0aXR1ZGUiOiItMTUuNzc5MDcyIiwibG9uZ2l0dWRlIjoiLTQ3LjkyOTIxNSJ9LCJjb21tdW5pY2F0aW9ucyI6eyJlbmNyeXB0aW9uIjoiQUVTLTI1NiJ9fQ==",
//     address: "0x976EA74026E726554dB657fA54763abd0C3a0aa9"
// };

// const decodedData = decodeBase64Data(exampleData);
// console.log(decodedData)


export default decodeBase64Data;