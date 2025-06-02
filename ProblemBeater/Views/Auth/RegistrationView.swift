//
//  RegistrationView.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//

import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var navManager: NavigationManager
    @EnvironmentObject var loadingState: LoadingState
    @State private var showImagePicker = false
    @FocusState private var isFocused: Bool
    
    @ObservedObject var viewModel = SignUpViewModel()
    var body: some View {
        VStack {
            Spacer(minLength: 1)
            ScrollView {
                HStack {
                    VStack(alignment: .leading) {
                        Spacer(minLength: 60)
                        // Profile Image
                        HStack {
                            Spacer()
                            ZStack(alignment: .bottomTrailing) {
                                Group {
                                    if let image = viewModel.selectedImage{
                                        Image(uiImage: image)
                                            .resizable()
                                    } else {
                                        Image(systemName: "person.circle")
                                            .resizable()
                                    }
                                }
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(.circle)
                                .overlay(Circle().stroke(.appColor3, lineWidth: 2))
                                Button {
                                    // Image Picker
                                    showImagePicker = true
                                } label: {
                                    Image(systemName: "person.crop.square.badge.camera.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.indigo)
                                        .frame(width: 30, height: 30)
                                }
                            }
                            Spacer()
                        }
                        .padding(.bottom, 30)
                        // Text
                        Text("Let's Sign Up.!")
                            .font(.system(size: 32, design: .rounded))
                            .bold()
                        // TextField
                        VStack(spacing: 16) {
                            TextFieldWithImage(placeHolderText: "Name", text: $viewModel.name)
                            TextFieldWithImage(placeHolderText: "Email", text: $viewModel.email, showIcon: true, iconName: "envelope.fill")
                            TextFieldWithImage(placeHolderText: "Mobile Number", text: $viewModel.mobile, showIcon: true, iconName: "phone.fill")
                                .keyboardType(.phonePad)
                            CustomSecureTextField(placeHolderText: "Password", text: $viewModel.password)
                            CustomSecureTextField(placeHolderText: "Confirm Password", text: $viewModel.confirmPassword)
                            CustomPickerView(placeHolderText: "Gender", dataSources: genders, text: $viewModel.selectedGender, showIcon: true, iconName: "figure.stand.dress.line.vertical.figure")
                            TextFieldWithImage(placeHolderText: "Age", text: $viewModel.age)
                                .keyboardType(.numberPad)
                                .focused($isFocused)
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        Button("Done") {
                                            isFocused = false // dismiss keyboard
                                        }
                                    }
                                }
                            CustomPickerView(placeHolderText: "Class", dataSources: viewModel.classes?.map{$0.name} ?? ["", ""], text: $viewModel.selectedClass, showIcon: true, iconName: "graduationcap.fill")
                            HStack {
                                Text("Already have an account?")
                                    .font(.system(size: 16, design: .rounded))
                                Button {
                                    // Forgot Password Action
                                    if !navManager.path.isEmpty {
                                        navManager.path.removeLast()
                                    }
                                } label: {
                                    Text("Sign In")
                                        .font(.system(size: 16, design: .rounded))
                                        .padding(.horizontal, -2)
                                }
                                Spacer()
                            }
                            .padding(EdgeInsets(top: -4, leading: 10, bottom: 0, trailing: 0))
                        }
                        AppButton(text: "Sign Up") {
                            viewModel.loadingState = loadingState
                            Task {
                                await viewModel.signUp()
                            }
                        }
                        .padding(.top, 30)
                    }
                    .padding()
                    Spacer()
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $viewModel.selectedImage)
            }
            .scrollIndicators(.hidden)
        }
        .spinnerOverlay(isLoading: loadingState.isLoading)
        .navigationBarHidden(true)
        .task {
            await viewModel.fetClasses()
        }
        .onChange(of: viewModel.signUpSuccess) { _, newValue in
            if newValue {
                Task {
                    await navManager.goToLogin(showToastMessage: true, message: "Registration Successful! Login to start you Journey")
                }
            }
        }
    }
}

#Preview {
    RegistrationView()
}
