import styled, { keyframes } from 'styled-components';

const ripple = keyframes`
  0% { transform: scale(1); box-shadow: rgba(0, 0, 0, 0.3) 0px 10px 10px -0px; }
  50% { transform: scale(1.3); box-shadow: rgba(0, 0, 0, 0.3) 0px 30px 20px -0px;}
  100% { transform: scale(1); box-shadow: rgba(0, 0, 0, 0.3) 0px 10px 10px -0px;}
`;

const colorChange = keyframes`
  0% { fill: grey; }
  50% { fill: white; }
  100% { fill: grey; }
`;

const LoaderContainer = styled.div`
  height: 300px;
  aspect-ratio: 1;
  background: black;
  position: relative;
`;

const Box = styled.div`
  position: absolute;
  background: rgba(100, 100, 100, 0.15);
//   background: linear-gradient(0deg, rgba(34, 40, 49, 0.2) 0%, rgba(57, 62, 70, 0.2) 100%);
  border-radius: 50%;
  border-top: 1px solid rgba(100, 100, 100, 1);
  box-shadow: rgba(0, 0, 0, 0.3) 0px 10px 10px -0px;
  backdrop-filter: blur(5px);
  animation: ${ripple} 2s infinite ease-in-out;

  &:nth-child(1) {
    inset: 40%;
    z-index: 99;
  }
  &:nth-child(2) {
    inset: 30%;
    z-index: 98;
    border-color: rgba(100, 100, 100, 0.8);
    animation-delay: 0.2s;
  }
  &:nth-child(3) {
    inset: 20%;
    z-index: 97;
    border-color: rgba(100, 100, 100, 0.6);
    animation-delay: 0.4s;
  }
  &:nth-child(4) {
    inset: 10%;
    z-index: 96;
    border-color: rgba(100, 100, 100, 0.4);
    animation-delay: 0.6s;
  }
  &:nth-child(5) {
    inset: 0%;
    z-index: 95;
    border-color: rgba(100, 100, 100, 0.2);
    animation-delay: 0.8s;
  }
`;


const Loader = () => {
  return (
    <LoaderContainer>
      <Box></Box>
      <Box></Box>
      <Box></Box>
      <Box></Box>
      <Box></Box>
    </LoaderContainer>
  );
};

export default Loader;
