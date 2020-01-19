import React from "react";
import axios, { post } from 'axios';

import { Container, Header } from 'semantic-ui-react'

class Home extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            file: null,
            students: []
        }
        this.onFormSubmit = this.onFormSubmit.bind(this)
        this.onChange = this.onChange.bind(this)
        this.fileUpload = this.fileUpload.bind(this)
    }

    onFormSubmit(e) {
        e.preventDefault() // Stop form submit
        this.fileUpload(this.state.file).then((response) => {
            console.log(response.data);
            const dataa = response.data;
            this.setState({
                students: dataa,
            });
        })
    }

    onChange(e) {
        this.setState({ file: e.target.files[0] })
    }

    fileUpload(file) {
        const url = 'http://localhost:5000/test';
        const formData = new FormData();
        formData.append('file', file)
        const config = {
            headers: {
                'content-type': 'multipart/form-data'
            }
        }
        return post(url, formData, config)
    }

    render() {
        return (
            <div>
                <Container>
                    <form onSubmit={this.onFormSubmit}>
                        <h1>Resim Yükleme Alanı</h1>
                        <input type="file" onChange={this.onChange} />
                        <button type="submit">Upload</button>
                    </form>
                </Container>
                <Container>
                    <Header as='h2'>Öğrenci Listesi</Header>
                    <hr/>
                    <ul>
                        {this.state.students.map((student) => {
                            return (
                                <li>
                                    {student.ad} {student.sinif} {student.koltuk}
                                </li>
                            )
                        })}
                    </ul>
                </Container>
            </div>
        );
    }
}

export default Home;