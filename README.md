# Automatic Music Generation
## @Andy: andy.chen@connect.polyu.hk
### To see the full documentation, refer to the milestone report or contact the author

# OBJECTIVE

  The objective of this project is to build a music composition system using machine learning algorithms. The scale of this system should be small in a sense that it generates a piece of short melody. The generated music can not only be used for further evaluation, but also serve as an input to a larger scale music generator to compose longer music. The generated music demonstrates explicit patterns similar to the inputted human composed music. The equipment needed for this system is a normal computer.
   
  This project will make attempt at a combined approach for music composition system and music evaluation system, i.e., to integrate two subsystems music generating system and music verification system into one. Since both topics are subjective to human evaluation, this project are expected to quantify the evaluation process. Once the performance can be evaluated, the project will be able to optimize the models in the sense of maximizing the quantitative performance.
    
# MUSIC VERIFICATION SYSTEM

  The function of the music verification system is to verify the outputted music of the generating system. This system distinguishes music from random noise. This system is important since it ensures the output quality of the whole system. This part should be implemented first since it is independent for the music generating system. Input: The data collected in music generating system or a piece of melody generated in the music generating system. The length of input is a musical sentence 8 measures.

Output: 0 or 1, indicating whether the inputted music is music or noise.
Model: The system is implemented using multiple Hidden Markov Models.
 
  Hidden Markov Model is a powerful tool to model stochastic process over time. For this system, we adopt multiple HMMs and a final boosting. It is suggested that Long Short-Term Memory Network LSTM is a possible method to generate music. It may as well applied to classification of music and noise. Due to the limited number of data and the scale of this system, LSTM is not adopted in this project.
